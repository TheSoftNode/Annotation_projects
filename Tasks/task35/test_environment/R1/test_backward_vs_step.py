import torch
import torch.nn as nn
import torch.optim as optim

model = nn.Linear(3, 1)
optimizer = optim.SGD(model.parameters(), lr=0.1)
x = torch.randn(1, 3)
target = torch.zeros(1, 1)
loss_fn = nn.MSELoss()

before = model.weight.detach().clone()
loss = loss_fn(model(x), target)
loss.backward()
after_backward = model.weight.detach().clone()
optimizer.step()
after_step = model.weight.detach().clone()

print("weights equal before vs after_backward:")
print(torch.equal(before, after_backward))
print("weights equal after_backward vs after_step:")
print(torch.equal(after_backward, after_step))
