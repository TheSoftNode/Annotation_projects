import torch
import torch.nn as nn

# Test gradient accumulation when calling the function multiple times without zero_grad()
def print_gradients_no_zero(model, x):
    output = model(x)
    target = torch.tensor([[0.]])
    loss = nn.MSELoss()
    loss = loss(output, target)
    loss.backward()

    for name, param in model.named_parameters():
        if 'weight' in name:
            print(f"{name} has gradient mean of {param.grad.abs().mean().item()}")

model = nn.Linear(3, 1)
x = torch.randn(1, 3)

# First call
print_gradients_no_zero(model, x)

# Second call without zero_grad() - gradients should accumulate
print_gradients_no_zero(model, x)
