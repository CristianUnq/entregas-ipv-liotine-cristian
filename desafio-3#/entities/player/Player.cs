using Godot;
using System;

// 1. Ahora heredamos de CharacterBody2D
public partial class Player : CharacterBody2D 
{
	private Sprite2D _cannon;

	[Export] public float Acceleration { get; set; } = 20.0f;
	[Export] public float HSpeedLimit { get; set; } = 600.0f;
	[Export] public float FrictionWeight { get; set; } = 0.1f;
	
	// Variables para el salto
	[Export] public float Gravity { get; set; } = 980.0f;
	[Export] public float JumpForce { get; set; } = -600.0f;

	private Node _projectileContainer;

	public override void _Ready()
	{
		_cannon = GetNode<Sprite2D>("Cannon");
	}

	public void Initialize(Node projectileContainer)
	{
		_projectileContainer = projectileContainer;
		_cannon.Set("ProjectileContainer", _projectileContainer);
	}

	public override void _PhysicsProcess(double delta)
	{
		float fDelta = (float)delta;
		
		// 2. Usamos la propiedad Velocity nativa de CharacterBody2D
		Vector2 currentVelocity = Velocity; 

		// --- GRAVEDAD Y SALTO ---
		// Si NO está en el piso, le aplicamos gravedad
		if (!IsOnFloor())
		{
			currentVelocity.Y += Gravity * fDelta;
		}

		// Si apretamos saltar Y además estamos tocando el piso, saltamos
		if (Input.IsActionJustPressed("jump") && IsOnFloor())
		{
			currentVelocity.Y = JumpForce;
		}

		// --- APUNTAR Y DISPARAR ---
		Vector2 mousePosition = GetGlobalMousePosition();
		_cannon.LookAt(mousePosition);

		if (Input.IsActionJustPressed("fire_cannon"))
		{
			if (_projectileContainer == null)
			{
				_projectileContainer = GetParent();
				_cannon.Set("ProjectileContainer", _projectileContainer);
			}
			_cannon.Call("Fire");
		}

		// --- MOVIMIENTO HORIZONTAL ---
		int hMovementDirection = 0;
		if (Input.IsActionPressed("move_right")) hMovementDirection += 1;
		if (Input.IsActionPressed("move_left")) hMovementDirection -= 1;

		if (hMovementDirection != 0)
		{
			currentVelocity.X = Mathf.Clamp(
				currentVelocity.X + (hMovementDirection * Acceleration),
				-HSpeedLimit,
				HSpeedLimit
			);
		}
		else
		{
			currentVelocity.X = Mathf.Abs(currentVelocity.X) > 1.0f 
				? Mathf.Lerp(currentVelocity.X, 0.0f, FrictionWeight) 
				: 0.0f;
		}

		// 3. Devolvemos los cálculos a la propiedad nativa y aplicamos la física
		Velocity = currentVelocity;
		
		// MoveAndSlide se encarga de mover al personaje y detectar choques 
		// automáticamente. Ya NO usamos "Position += ...". Tampoco le multiplicamos
		// el delta acá, MoveAndSlide lo hace por detrás.
		MoveAndSlide(); 
	}
}
