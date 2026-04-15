def print_gradients(model, x):
output = model(x) #1
target = torch.tensor([[0.]])
loss = nn.MSELoss()
loss = loss(output, target) #2
loss.backward() #3
for name, param in model.named_parameters():
if 'weight' in name:
print(f"{name} has gradient mean of {param.grad.abs().mean().item
()}")
