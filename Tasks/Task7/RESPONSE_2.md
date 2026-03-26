Below is a **complete, copy‑and‑paste ready** guide that shows you how to send every metric that you emit with `self.log()` (or `self.log_dict()`) from a PyTorch‑Lightning module to [**Neptune.ai**](http://neptune.ai/) (the service you probably meant by “[Netune.ai](http://netune.ai/)”).

---

## **1\. Install the required packages**

\# Core libraries

pip install lightning torch torchmetrics   \# lightning \= the new PyTorch‑Lightning package

\# Neptune logger (the official Lightning integration)

pip install neptune neptune-new\[lightning\]   \# the extra \`\[lightning\]\` pulls in the logger

**Why `neptune-new`?**  
The `neptune` package (v1) is the legacy client; the newer `neptune-new` (v2) is the one that ships the `NeptuneLogger` used by Lightning. Installing the extra `[lightning]` makes sure the logger’s dependencies are present.

---

## **2\. Get your Neptune credentials**

1. Create a free (or paid) account at [https://neptune.ai](https://neptune.ai/).  
2. In the UI go to **My Profile → API Tokens** and copy your **API token**.  
3. Note the **project name** – it looks like `username/project-name`.

You can either:

* **Pass them explicitly** when you instantiate the logger (see code below), **or**  
* **Export them as environment variables** (recommended for CI / notebooks):

export NEPTUNE\_API\_TOKEN="your‑very‑long‑token"

export NEPTUNE\_PROJECT="username/project-name"

If the env‑vars are set, you can omit the arguments to `NeptuneLogger`.

---

## **3\. Minimal Lightning module (unchanged except for the logger)**

\# models/fc\_classifier.py  (same as in the previous answer)

import torch

import torch.nn as nn

import lightning as L

from torchmetrics.classification import Accuracy

class FCClassifier(L.LightningModule):

    def \_\_init\_\_(self, cfg):

        super().\_\_init\_\_()

        self.cfg \= cfg

        self.save\_hyperparameters()          \# logs the Config dict automatically

        \# \----- build a simple MLP \-------------------------------------------------

        layers \= \[\]

        in\_features \= cfg.input\_dim

        for h in cfg.hidden\_dims:

            layers \+= \[

                nn.Linear(in\_features, h),

                nn.BatchNorm1d(h),

                nn.ReLU(),

                nn.Dropout(cfg.dropout),

            \]

            in\_features \= h

        layers.append(nn.Linear(in\_features, cfg.n\_classes))

        self.net \= nn.Sequential(\*layers)

        \# \-------------------------------------------------------------------------

        self.loss\_fn \= nn.CrossEntropyLoss()

        self.train\_acc \= Accuracy(task="multiclass", num\_classes=cfg.n\_classes)

        self.val\_acc   \= Accuracy(task="multiclass", num\_classes=cfg.n\_classes)

    def forward(self, x):

        return self.net(x)          \# logits

    \# \------------------------------------------------------------------ \#

    def training\_step(self, batch, batch\_idx):

        logits \= self(batch\["x"\])

        loss   \= self.loss\_fn(logits, batch\["y\_class"\])

        acc    \= self.train\_acc(logits.softmax(-1), batch\["y\_class"\])

        \# \<-- self.log automatically forwards to every attached logger

        self.log("train\_loss", loss, prog\_bar=True, logger=True)

        self.log("train\_acc",  acc,  prog\_bar=True, logger=True)

        return loss

    def validation\_step(self, batch, batch\_idx):

        logits \= self(batch\["x"\])

        loss   \= self.loss\_fn(logits, batch\["y\_class"\])

        acc    \= self.val\_acc(logits.softmax(-1), batch\["y\_class"\])

        self.log("val\_loss", loss, prog\_bar=True, logger=True)

        self.log("val\_acc",  acc,  prog\_bar=True, logger=True)

    def configure\_optimizers(self):

        opt \= torch.optim.AdamW(self.parameters(), lr=self.cfg.lr)

        sch \= torch.optim.lr\_scheduler.CosineAnnealingLR(opt, T\_max=10)

        return \[opt\], \[sch\]

**Important:** You **do not** need to change anything inside the module to make Neptune work – `self.log()` already knows how to push the values to any logger that the `Trainer` holds.

---

## **4\. Wire the Neptune logger into the `Trainer`**

\# train.py

import lightning as L

from lightning.pytorch.loggers import NeptuneLogger   \# \<-- note the import path

from config import Config

from data.dummy\_dataset import get\_dataloaders

from models.fc\_classifier import FCClassifier

def main():

    cfg \= Config()

    train\_loader, val\_loader \= get\_dataloaders(cfg)

    model \= FCClassifier(cfg)

    \# \-------------------  NeptuneLogger  \-------------------

    \# If you exported NEPTUNE\_API\_TOKEN & NEPTUNE\_PROJECT as env vars,

    \# you can omit the arguments below.

    neptune\_logger \= NeptuneLogger(

        api\_key="YOUR\_NEPTUNE\_API\_TOKEN",          \# or leave empty to read from env

        project="username/project-name",           \# or leave empty to read from env

        \# Optional but handy:

        tags=\["baseline", "fc-net", "cora"\],       \# appear in the UI

        name="fc-classifier-run",                  \# run name (defaults to timestamp)

        log\_model\_checkpoints=False,               \# we'll handle checkpointing ourselves

    )

    \# \-------------------------------------------------------

    \# Callbacks (checkpoint \+ early stopping)

    checkpoint\_cb \= L.callbacks.ModelCheckpoint(

        dirpath="checkpoints/",

        filename="{epoch}-{val\_loss:.4f}",

        monitor="val\_loss",

        mode="min",

        save\_top\_k=3,

    )

    early\_stop\_cb \= L.callbacks.EarlyStopping(

        monitor="val\_loss",

        patience=10,

        mode="min",

        verbose=True,

    )

    trainer \= L.Trainer(

        max\_epochs=cfg.n\_epochs,

        logger=neptune\_logger,          \# \<-- attach the logger here

        callbacks=\[checkpoint\_cb, early\_stop\_cb\],

        accelerator="auto",

        devices=None,

        log\_every\_n\_steps=50,

        strategy="auto",

    )

    trainer.fit(model, train\_loader, val\_loader)

    \# Optional: after training you can also upload the best checkpoint as an artifact

    best\_path \= checkpoint\_cb.best\_model\_path

    if best\_path:

        neptune\_logger.experiment\["model/best"\].upload(best\_path)

if \_\_name\_\_ \== "\_\_main\_\_":

    main()

### **What happens under the hood?**

* `self.log(name, value, ...)` puts the pair `(name, value)` into Lightning’s internal **logging buffer**.  
* At the end of each training/validation step the trainer iterates over **all attached loggers** (in this case just the `NeptuneLogger`) and calls their `log_metrics` method.  
* The `NeptuneLogger` then forwards the payload to the Neptune server via the `neptune-new` Python client, where it appears under the **Metrics** tab of the run.

You can also log **hyper‑parameters**, **text**, **images**, **matplotlib figures**, etc., directly from the logger if you need more than scalar metrics:

\# Inside any LightningMethod (e.g., on\_train\_start)

self.logger.experiment\["params/batch\_size"\] \= self.cfg.batch\_size

self.logger.experiment\["sys/tags"\].add(\["debug"\])

\# For a matplotlib figure:

import matplotlib.pyplot as plt

fig, ax \= plt.subplots()

ax.plot(\[0,1,2\], \[0,1,0\])

self.logger.experiment\["charts/loss\_curve"\].upload(fig)

**Tip:** The `self.logger` attribute inside a `LightningModule` is the *first* logger attached to the trainer (if you have multiple, you can access them via `self.loggers`).

---

## **5\. Full minimal reproducible example (synthetic data)**

If you just want to see it work without fiddling with a real dataset, here’s a self‑contained script that creates a tiny random dataset, defines the same `FCClassifier`, and logs to Neptune.

\# demo\_neptune.py

import os

import torch

from torch.utils.data import Dataset, DataLoader

import lightning as L

from lightning.pytorch.loggers import NeptuneLogger

from torchmetrics.classification import Accuracy

\# \---------- 1️⃣  Dummy dataset \----------

class RandomDataset(Dataset):

    def \_\_init\_\_(self, n\_samples, input\_dim, n\_classes):

        self.X \= torch.randn(n\_samples, input\_dim)

        self.y \= torch.randint(0, n\_classes, (n\_samples,))

    def \_\_len\_\_(self): return len(self.X)

    def \_\_getitem\_\_(self, idx): return {"x": self.X\[idx\], "y\_class": self.y\[idx\]}

\# \---------- 2️⃣  Lightning module \----------

class SimpleClassifier(L.LightningModule):

    def \_\_init\_\_(self, input\_dim=20, hidden\_dims=\[64,32\], n\_classes=5, lr=1e-3):

        super().\_\_init\_\_()

        self.save\_hyperparameters()

        layers \= \[\]

        in\_f \= input\_dim

        for h in hidden\_dims:

            layers \+= \[nn.Linear(in\_f, h), nn.ReLU(), nn.Dropout(0.2)\]

            in\_f \= h

        layers.append(nn.Linear(in\_f, n\_classes))

        self.net \= nn.Sequential(\*layers)

        self.loss \= nn.CrossEntropyLoss()

        self.train\_acc \= Accuracy(task="multiclass", num\_classes=n\_classes)

        self.val\_acc   \= Accuracy(task="multiclass", num\_classes=n\_classes)

    def forward(self, x): return self.net(x)

    def training\_step(self, batch, \_):

        logits \= self(batch\["x"\])

        loss   \= self.loss(logits, batch\["y\_class"\])

        acc    \= self.train\_acc(logits.softmax(-1), batch\["y\_class"\])

        self.log("train\_loss", loss, prog\_bar=True)

        self.log("train\_acc",  acc,  prog\_bar=True)

        return loss

    def validation\_step(self, batch, \_):

        logits \= self(batch\["x"\])

        loss   \= self.loss(logits, batch\["y\_class"\])

        acc    \= self.val\_acc(logits.softmax(-1), batch\["y\_class"\])

        self.log("val\_loss", loss, prog\_bar=True)

        self.log("val\_acc",  acc,  prog\_bar=True)

    def configure\_optimizers(self):

        opt \= torch.optim.Adam(self.parameters(), lr=self.hparams.lr)

        return opt

\# \---------- 3️⃣  Neptune logger \----------

neptune\_logger \= NeptuneLogger(

    api\_key=os.getenv("NEPTUNE\_API\_TOKEN"),   \# set env var or put the string directly

    project=os.getenv("NEPTUNE\_PROJECT"),

    tags=\["demo", "synthetic"\],

    name="quick-demo",

)

\# \---------- 4️⃣  Trainer \----------

trainer \= L.Trainer(

    max\_epochs=5,

    logger=neptune\_logger,

    accelerator="auto",

    devices=None,

    log\_every\_n\_steps=10,

)

\# \---------- 5️⃣  Data \----------

train\_dl \= DataLoader(RandomDataset(800, 20, 5), batch\_size=64, shuffle=True)

val\_dl   \= DataLoader(RandomDataset(200, 20, 5), batch\_size=64)

\# \---------- 6️⃣  Fit \----------

trainer.fit(SimpleClassifier(), train\_dl, val\_dl)

Run it:

export NEPTUNE\_API\_TOKEN="your-token-here"

export NEPTUNE\_PROJECT="your-username/your-project"

python demo\_neptune.py

Open the run URL that appears in the console (or go to Neptune → **Projects → your‑project → Runs**) and you’ll see the four scalar metrics (`train_loss`, `train_acc`, `val_loss`, `val_acc`) plotted automatically.

---

## **6\. Frequently asked variations**

| Want to … | How to do it |
| ----- | ----- |
| **Log the config as a single artifact** | `neptune_logger.experiment["config"].upload("config.yaml")` (after you dump your `Config` to YAML/JSON). |
| **Log multiple loggers (e.g., TensorBoard \+ Neptune)** | `trainer = L.Trainer(logger=[tb_logger, neptune_logger], …)` |
| **Log only at epoch end (not every step)** | In `self.log`, set `on_step=False, on_epoch=True`. Example: `self.log("val_acc", acc, on_step=False, on_epoch=True, prog_bar=True)`. |
| **Disable Neptune for a quick debug run** | Pass `logger=False` to the `Trainer` or set `NEPTUNE_MODE="debug"` (the client will then write to a local folder instead of the server). |
| **Use the old `pytorch_lightning` import style** | Replace `from lightning.pytorch.loggers import NeptuneLogger` with `from pytorch_lightning.loggers import NeptuneLogger`. The rest of the code stays identical. |

---

## **7\. TL;DR checklist**

1. **Install** `lightning`, `neptune-new[lightning]`.  
2. **Set** `NEPTUNE_API_TOKEN` and `NEPTUNE_PROJECT` (or pass them to `NeptuneLogger`).  
3. **Create** a `NeptuneLogger` instance.  
4. **Pass** that logger to `Trainer(logger=…)`.  
5. **Inside your LightningModule** keep using `self.log()` (or `self.log_dict()`) exactly as before.  
6. (Optional) **Upload** artifacts, configs, or custom charts via `self.logger.experiment[...]`.

That’s all you need – Lightning handles the rest, and Neptune will show you live metrics, system monitors, and any extra artifacts you decide to upload. Happy experimenting\! 🚀
