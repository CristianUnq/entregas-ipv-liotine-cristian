using Godot;
using System;

public partial class Turret : StaticBody2D
{
	// Referencias a los nodos hijos (equivalente a @onready)
	private Node2D _firePosition;
	private Timer _fireTimer;
	private RayCast2D _rayCast;

	// Escena del proyectil (equivalente a @export)
	[Export]
	public PackedScene ProjectileScene { get; set; }

	private Node2D _player;
	//private Node _projectileContainer;

	public override void _Ready()
	{
		// Inicializamos los nodos hijos
		_firePosition = GetNode<Node2D>("FirePosition");
		_fireTimer = GetNode<Timer>("FireTimer");
		_rayCast = GetNode<RayCast2D>("RayCast2D");
	}

	public void Initialize(Node2D player)
	{
		GlobalPosition = this.GlobalPosition;
		_player = player;
		//_projectileContainer = projectileContainer;

		// Conectar la señal 'timeout' usando el sistema de eventos de C#
		_fireTimer.Timeout += OnFireTimerTimeout;
		
		// Iniciamos el temporizador de disparo
		_fireTimer.Start();
	}

	public void OnFireTimerTimeout()
	{
		FireAtPlayer();
	}

	public void FireAtPlayer()
	{
		// 1. Apuntamos el RayCast hacia el jugador
		// Calculamos la dirección y distancia
		Vector2 targetPosition = _player.GlobalPosition - GlobalPosition;
		_rayCast.TargetPosition = targetPosition;
		
		// 2. Forzamos al RayCast a actualizarse ahora mismo
		_rayCast.ForceRaycastUpdate();
	
		// 3. Chequeamos con qué chocó el láser
		if (_rayCast.IsColliding())
		{
			var collider = _rayCast.GetCollider();

			// Si el objeto con el que choca es el Player, entonces disparamos
			if (collider == _player)
			{
				InstanciarProyectil();
			}
			else
			{
				// Si chocó con otra cosa (una pared), no hacemos nada
				GD.Print("Hay una pared en medio, no disparo.");
			}
		}
	}
	
	private void InstanciarProyectil() {
		
		if (ProjectileScene == null)
		{
			GD.PrintErr($"Error: ProjectileScene no asignada en {Name}");
			return;
		}
		
		if (ProjectileScene.Instantiate() is Node2D projInstance)
		{
			// Calculamos la dirección desde el punto de disparo hacia el jugador
			Vector2 direction = _firePosition.GlobalPosition.DirectionTo(_player.GlobalPosition);

			// Llamamos al Initialize del proyectil (asegúrate de que sea PUBLIC en el script de la bala)
			projInstance.Call("Initialize", 
				this, 
				_firePosition.GlobalPosition, 
				direction
			);
		}
	}
	
	public void Die() {
		GD.Print("La torreta ha muerto.");
		QueueFree();
	}
	
}
