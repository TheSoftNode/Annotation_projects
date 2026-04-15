def print_gradients(model, x):
    # 1. Forward pass: Run input x through the neural network model
    output = model(x)  # Calculates the model's prediction for input x

    # Create a target tensor (ground truth) for loss calculation
    # Typically this would come from your training data
    target = torch.tensor([[0.]])  # Creates a tensor with value 0

    # Instantiate the Mean Squared Error loss function
    loss = nn.MSELoss()  # Initializes MSE loss: (prediction - target)^2

    # 2. Calculate the loss between model output and target
    loss = loss(output, target)  # Computes MSE: (output - 0)^2

    # 3. Backward pass: Compute gradients via backpropagation
    loss.backward()  # This computes gradients for ALL trainable parameters

    # Iterate through all named parameters in the model
    for name, param in model.named_parameters():
        # Filter to only look at weight parameters (not biases)
        if 'weight' in name:
            # Print gradient statistics for each weight parameter
            print(f"{name} has gradient mean of {param.grad.abs().mean().item()}")
