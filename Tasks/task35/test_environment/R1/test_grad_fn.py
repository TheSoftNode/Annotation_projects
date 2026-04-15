import torch
import torch.nn as nn

x = torch.randn(1, 1, requires_grad=True)
target = torch.tensor([[0.]])
loss = nn.MSELoss()(x, target)
print(loss)
print(loss.grad_fn)
