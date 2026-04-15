import torch
import torch.nn as nn

# Test shape mismatch warning with hard-coded (1,1) target
model = nn.Sequential(nn.Linear(3, 8), nn.Linear(8, 4), nn.Linear(4, 2))
x = torch.randn(4, 3)  # batch of 4, outputs (4, 2)

output = model(x)
print(output.shape)

# Hard-coded (1, 1) target
target = torch.tensor([[0.]])
loss_fn = nn.MSELoss()
loss = loss_fn(output, target)
print(loss)
