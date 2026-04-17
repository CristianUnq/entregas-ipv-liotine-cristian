using Godot;
using System;

public partial class TurretSpawner : Node
{
	// Usamos el atributo [Export] para que aparezca en el Inspector
	[Export]
	public PackedScene TurretScene { get; set; }

	public void Initialize(CharacterBody2D player)
	{
		// Obtenemos el rectángulo visible del viewport
		Rect2 visibleRect = GetViewport().GetVisibleRect();

		for (int i = 0; i < 3; i++)
		{
			// Instanciamos la escena. Es necesario hacer un cast a Node2D 
			// porque Instantiate() devuelve un tipo Node genérico.
			if (TurretScene.Instantiate() is Node2D turretInstance)
			{
				// Generamos la posición aleatoria
				float posX = (float)GD.RandRange(visibleRect.Position.X, visibleRect.End.X);
				float posY = (float)GD.RandRange(visibleRect.Position.Y + 30, player.GlobalPosition.Y - 50);
				
				Vector2 turretPos = new Vector2(posX, posY);

				// Añadimos el hijo a la escena
				AddChild(turretInstance);

				// Llamamos al método Initialize de la torreta
				// Asegúrate de que Turret.cs tenga un método public void Initialize(...)
				turretInstance.Call("Initialize", turretPos, player, this);
				
				// Nota: Si quieres llamar al método directamente sin usar Call, 
				// deberías castear turretInstance a tu clase específica (ej: Turret).
			}
		}
	}
}
