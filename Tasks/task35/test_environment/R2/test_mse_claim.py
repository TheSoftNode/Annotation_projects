import torch
import torch.nn as nn

output = torch.tensor([[2.0]])
target = torch.tensor([[0.0]])
loss_fn = nn.MSELoss()
loss = loss_fn(output, target)
manual = (output - target) ** 2

print("loss =", loss)
print("manual =", manual)
print("equal =", torch.equal(loss, manual))
