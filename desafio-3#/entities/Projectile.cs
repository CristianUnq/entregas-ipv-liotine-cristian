using Godot;
using System;

public partial class Projectile : Sprite2D
{
	// Referencia al Timer (equivalente a @onready)
	private Timer _lifetimeTimer;

	[Export]
	public float Velocity { get; set; } = 800.0f;

	private Vector2 _direction;

	public override void _Ready()
	{
		// Obtenemos el nodo Timer
		_lifetimeTimer = GetNode<Timer>("LifetimeTimer");
	}

	public void Initialize(Node container, Vector2 spawnPosition, Vector2 direction)
	{
		// Agregamos la bala al contenedor (ej: el Main o un Node dedicado a balas)
		container.AddChild(this);
		
		_direction = direction;
		GlobalPosition = spawnPosition;

		// Conectar la señal 'timeout' usando el sistema de eventos de C# (más limpio)
		_lifetimeTimer.Timeout += OnLifetimeTimerTimeout;
		
		// Iniciamos el timer
		_lifetimeTimer.Start();
	}

	public override void _PhysicsProcess(double delta)
	{
		// Movimiento
		Position += _direction * Velocity * (float)delta;

		// Si está fuera de la pantalla, lo removemos
		Rect2 visibleRect = GetViewport().GetVisibleRect();
		if (!visibleRect.HasPoint(GlobalPosition))
		{
			RemoveProjectile();
		}
	}

	// El manejador del evento timeout
	private void OnLifetimeTimerTimeout()
	{
		RemoveProjectile();
	}

	private void RemoveProjectile()
	{
		// Verificamos si tiene padre antes de intentar removerlo
		Node parent = GetParent();
		if (parent != null)
		{
			parent.RemoveChild(this);
		}
		
		// Liberamos la memoria del nodo
		QueueFree();
	}
}
