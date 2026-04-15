import torch
import torch.nn as nn

# Test each explanation claim from R2

print("=== Testing Claim: MSE formula (prediction - target)^2 ===")
output = torch.tensor([[2.0]])
target = torch.tensor([[0.0]])
loss_fn = nn.MSELoss()
loss = loss_fn(output, target)
manual_squared = (output - target) ** 2
manual_mean = manual_squared.mean()
print(f"MSELoss result: {loss}")
print(f"Manual (output-target)^2: {manual_squared}")
print(f"Manual mean of squared diff: {manual_mean}")
print(f"Comment says: (prediction - target)^2")
print(f"Accurate? MSELoss applies mean reduction by default")
print()

print("=== Testing Claim: loss.backward() computes for ALL trainable parameters ===")
class ModelWithUnused(nn.Module):
    def __init__(self):
        super().__init__()
        self.used = nn.Linear(2, 1)
        self.unused = nn.Linear(2, 1)

    def forward(self, x):
        return self.used(x)

model = ModelWithUnused()
x = torch.randn(1, 2)
output = model(x)
target = torch.tensor([[0.]])
loss = nn.MSELoss()(output, target)
loss.backward()

print("Parameters and their gradients:")
for name, param in model.named_parameters():
    print(f"{name}: grad is None = {param.grad is None}")
print(f"Claim says: ALL trainable parameters")
print(f"Accurate? Only parameters in computation graph get gradients")
print()

print("=== Testing Claim: .abs().mean() gives average magnitude ===")
grad = torch.tensor([[-1.0, 2.0, -3.0]])
abs_vals = grad.abs()
mean_val = abs_vals.mean()
print(f"Original: {grad}")
print(f"After .abs(): {abs_vals}")
print(f"After .mean(): {mean_val}")
print(f"Manual calculation: (1+2+3)/3 = {(1+2+3)/3}")
print(f"Claim: gives average magnitude of gradients")
print(f"Accurate? Yes")
print()

print("=== Testing Claim: .item() converts to Python number ===")
tensor_val = torch.tensor(3.14)
python_val = tensor_val.item()
print(f"Tensor: {tensor_val}, type: {type(tensor_val)}")
print(f"After .item(): {python_val}, type: {type(python_val)}")
print(f"Claim: converts single-value tensor to Python number")
print(f"Accurate? Yes")
print()

print("=== Testing Claim: After backward(), .grad contains gradient ===")
model = nn.Linear(2, 1)
x = torch.randn(1, 2)
target = torch.tensor([[0.]])

print("Before backward:")
print(f"weight.grad: {model.weight.grad}")
print(f"bias.grad: {model.bias.grad}")

output = model(x)
loss = nn.MSELoss()(output, target)
loss.backward()

print("\nAfter backward:")
print(f"weight.grad is not None: {model.weight.grad is not None}")
print(f"bias.grad is not None: {model.bias.grad is not None}")
print(f"Claim: each parameter's .grad attribute contains the gradient")
print(f"Accurate? Yes, for parameters in the computation graph")
