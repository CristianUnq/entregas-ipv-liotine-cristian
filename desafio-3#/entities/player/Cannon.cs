using Godot;
using System;

public partial class Cannon : Sprite2D
{
	// Referencia al nodo hijo (equivalente a @onready)
	private Node2D _cannonTip;

	// Escena del proyectil (equivalente a @export)
	[Export]
	public PackedScene ProjectileScene { get; set; }

	// Contenedor que se asignará desde fuera
	public Node ProjectileContainer { get; set; }

	public override void _Ready()
	{
		// Inicializamos la referencia al CannonTip
		_cannonTip = GetNode<Node2D>("CannonTip");
	}

	public void Fire()
	{
		// Verificamos que la escena del proyectil esté asignada en el Inspector
		if (ProjectileScene == null)
		{
			GD.PrintErr("Error: ProjectileScene no asignada en el Inspector de " + Name);
			return;
		}

		// Instanciamos el proyectil
		if (ProjectileScene.Instantiate() is Node2D projInstance)
		{
			// Calculamos la dirección hacia donde apunta el cañón
			Vector2 direction = GlobalPosition.DirectionTo(_cannonTip.GlobalPosition);

			// Llamamos al Initialize del proyectil
			// Asegúrate de que el script del proyectil tenga un método PUBLIC Initialize
			projInstance.Call("Initialize", 
				ProjectileContainer, 
				_cannonTip.GlobalPosition, 
				direction
			);
		}
	}
}
