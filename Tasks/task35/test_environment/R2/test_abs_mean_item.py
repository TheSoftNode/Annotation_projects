import torch

g = torch.tensor([[-1.0, 2.0, -3.0]])
result = g.abs().mean().item()
print("result =", result)
print("type =", type(result))
