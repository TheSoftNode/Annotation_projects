import torch
import torch.nn as nn

# Test the hard-coded (1,1) target with different output shapes
model = nn.Sequential(nn.Linear(3, 8), nn.Linear(8, 4), nn.Linear(4, 2))  # outputs shape (1, 2) with batch size 1
x = torch.randn(4, 3)  # batch of 4 samples

output = model(x)
print(output.shape)

# Using the hard-coded target from R1
target = torch.tensor([[0.]], dtype=output.dtype, device=output.device)
loss_fn = nn.MSELoss()
loss = loss_fn(output, target)
print(loss)
