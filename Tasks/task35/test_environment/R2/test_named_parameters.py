import torch.nn as nn

model = nn.Sequential(nn.Linear(3, 2))
for name, param in model.named_parameters():
    print(name, type(param).__name__)
