import torch
import torch.nn as nn

class TwoLayerModel(nn.Module):
    def __init__(self):
        super().__init__()
        self.used = nn.Linear(3, 1)
        self.unused = nn.Linear(3, 1)

    def forward(self, x):
        return self.used(x)

model = TwoLayerModel()
x = torch.randn(1, 3)
target = torch.tensor([[0.]])
loss_fn = nn.MSELoss()
output = model(x)
loss = loss_fn(output, target)
loss.backward()

for name, param in model.named_parameters():
    print(name, "grad is None ->", param.grad is None)
