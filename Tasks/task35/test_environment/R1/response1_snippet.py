import torch
import torch.nn as nn

def print_gradients(model, x):
    # 1️⃣  Forward pass – compute the model's prediction for the input `x`
    output = model(x)                                 # 1

    # 2️⃣  Build a dummy target and a loss function, then compute the loss
    target = torch.tensor([[0.]], dtype=output.dtype, device=output.device)  # same device/type
    loss_fn = nn.MSELoss()                           # mean-squared-error loss
    loss = loss_fn(output, target)                   # 2

    # 3️⃣  Back-propagation – populate `.grad` for every leaf Tensor that requires grad
    loss.backward()                                  # 3

    # 4️⃣  Loop over the model's parameters, printing the mean absolute gradient
    for name, param in model.named_parameters():
        if 'weight' in name:                          # only look at weight tensors, not biases
            # `param.grad` holds the gradient of `loss` w.r.t. this weight
            grad_mean = param.grad.abs().mean().item()
            print(f"{name} has gradient mean of {grad_mean}")
