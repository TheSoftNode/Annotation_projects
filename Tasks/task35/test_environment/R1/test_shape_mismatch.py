import torch
import torch.nn as nn

input = torch.randn(1, 1, requires_grad=True)
target = torch.randn(2, 2)
loss = nn.MSELoss()(input, target)
print(loss)
