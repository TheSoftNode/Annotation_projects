import torch
import torch.nn as nn

model = nn.Linear(3, 1)
x = torch.randn(1, 3)
target = torch.tensor([[0.]])
loss_fn = nn.MSELoss()

print("before backward:")
for name, param in model.named_parameters():
    print(name, param.grad)

loss = loss_fn(model(x), target)
loss.backward()

print("after backward:")
for name, param in model.named_parameters():
    print(name, param.grad is None)
