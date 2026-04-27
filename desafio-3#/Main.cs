using Godot;
using System;

public partial class Main : Node
{
	private Camera2D _camera;
	private CharacterBody2D _player;
	private StaticBody2D _turret;
	private StaticBody2D _turret2;

	public override void _Ready()
	{
		// El equivalente a @onready: obtenemos los nodos al iniciar.
		// Asegúrate de que los nombres coincidan exactamente con tu árbol de escenas.
		_camera = GetNode<Camera2D>("Camera2D");
		_player = GetNode<CharacterBody2D>("Player");
		_turret = GetNode<StaticBody2D>("Turret");
		_turret2 = GetNode<StaticBody2D>("Turret2");
		
		// En Godot 4, ya no es estrictamente necesario llamar a GD.Randomize() 
		// ya que se hace automáticamente, pero es bueno mantener la lógica.
		GD.Randomize();

		// Llamamos a los métodos de inicialización.
		// Nota: Asegúrate de que en Player.cs y TurretSpawner.cs
		// los métodos Initialize sean 'public'.
		_player.Call("Initialize", this);
		//_turretSpawner.Call("Initialize", _player);
		_turret.Call("Initialize", _player);
		_turret2.Call("Initialize", _player);
	}
	
	public override void _Process(double delta)
	{
		// La cámara sigue la posición del jugador en cada frame
		_camera.Position = _player.Position;
	}
}
