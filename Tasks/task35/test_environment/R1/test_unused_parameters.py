import torch
import torch.nn as nn

# Create a model with both used and unused parameters
class ModelWithUnused(nn.Module):
    def __init__(self):
        super().__init__()
        self.used = nn.Linear(2, 1)
        self.unused = nn.Linear(2, 1)  # This won't be used in forward

    def forward(self, x):
        return self.used(x)  # Only uses self.used

model = ModelWithUnused()
x = torch.randn(1, 2)

# Forward pass
output = model(x)

# Create target and loss
target = torch.tensor([[0.]], dtype=output.dtype, device=output.device)
loss_fn = nn.MSELoss()
loss = loss_fn(output, target)

# Backward pass
loss.backward()

# Check which parameters have gradients
for name, param in model.named_parameters():
    print(f"{name} grad is None -> {param.grad is None}")
