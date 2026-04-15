import torch
import torch.nn as nn
from response2_code import print_gradients

model = nn.Sequential(nn.Linear(3, 1))
x = torch.randn(1, 3)
print_gradients(model, x)
