using Godot;
using System;

public partial class Turret : Sprite2D
{
	// Referencias a los nodos hijos (equivalente a @onready)
	private Node2D _firePosition;
	private Timer _fireTimer;

	// Escena del proyectil (equivalente a @export)
	[Export]
	public PackedScene ProjectileScene { get; set; }

	private Node2D _player;
	private Node _projectileContainer;

	public override void _Ready()
	{
		// Inicializamos los nodos hijos
		_firePosition = GetNode<Node2D>("FirePosition");
		_fireTimer = GetNode<Timer>("FireTimer");
	}

	public void Initialize(Vector2 turretPos, Node2D player, Node projectileContainer)
	{
		GlobalPosition = turretPos;
		_player = player;
		_projectileContainer = projectileContainer;

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
		// Validación de seguridad para la escena del proyectil
		if (ProjectileScene == null)
		{
			GD.PrintErr($"Error: ProjectileScene no asignada en {Name}");
			return;
		}

		// Instanciamos el proyectil
		if (ProjectileScene.Instantiate() is Node2D projInstance)
		{
			// Calculamos la dirección desde el punto de disparo hacia el jugador
			Vector2 direction = _firePosition.GlobalPosition.DirectionTo(_player.GlobalPosition);

			// Llamamos al Initialize del proyectil (asegúrate de que sea PUBLIC en el script de la bala)
			projInstance.Call("Initialize", 
				_projectileContainer, 
				_firePosition.GlobalPosition, 
				direction
			);
		}
	}
}
