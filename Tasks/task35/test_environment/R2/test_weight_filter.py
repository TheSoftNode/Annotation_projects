import torch.nn as nn

model = nn.Sequential(nn.Linear(3, 2))
for name, param in model.named_parameters():
    if 'weight' in name:
        print("selected:", name)
    else:
        print("not selected:", name)
