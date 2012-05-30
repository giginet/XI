import UnityEngine

class Wall (MonoBehaviour):
	public direction as Direction
	private defaultPosition as Vector3

	def Start ():
		defaultPosition = self.transform.localPosition
	
	def Update ():
		pass
		
	def RollDice(player as Aqui):
		dice = player.currentDice.GetComponent[of Dice]()
		if dice.CanRolling(self.direction):
			dice.SendMessage("SetOwner", player)
			dice.SendMessage("StartRotate", self.direction)
			player.SendMessage("StartRolling", self)

	def ToggleEnable(toggle as bool):
		collider.enabled = toggle
		renderer.enabled = toggle	

	def Disable():
		self.ToggleEnable(false)
		
	def Enable():
		self.ToggleEnable(true)
