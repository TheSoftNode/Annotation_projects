import torch
import torch.nn as nn

model = nn.Linear(3, 1)
x = torch.randn(1, 3)
target = torch.zeros(1, 1)
loss_fn = nn.MSELoss()

loss = loss_fn(model(x), target)
loss.backward()
first = model.weight.grad.clone()

loss = loss_fn(model(x), target)
loss.backward()
second = model.weight.grad.clone()

print("first grad:")
print(first)
print("second grad:")
print(second)
print("same as doubled first (approximately):")
print(torch.allclose(second, first * 2, atol=1e-6))
