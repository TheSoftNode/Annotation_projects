import torch
import torch.nn as nn

# Create a model with BatchNorm to test if running stats appear in named_parameters()
class ModelWithBatchNorm(nn.Module):
    def __init__(self):
        super().__init__()
        self.linear = nn.Linear(3, 2)
        self.bn = nn.BatchNorm1d(2)  # Has running_mean and running_var buffers

    def forward(self, x):
        x = self.linear(x)
        x = self.bn(x)
        return x

model = ModelWithBatchNorm()

print("=== named_parameters() ===")
for name, param in model.named_parameters():
    print(f"{name}: {type(param).__name__}")

print("\n=== named_buffers() ===")
for name, buffer in model.named_buffers():
    print(f"{name}: {type(buffer).__name__}")
