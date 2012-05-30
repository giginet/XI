import UnityEngine

class Wall (MonoBehaviour):
	public direction as Direction
	public dice as Dice
	private defaultPosition as Vector3

	def Start ():
		defaultPosition = self.transform.localPosition
	
	def Update ():
		self.transform.position = self.dice.transform.position + self.defaultPosition * Setting.DICE_SIZE
		
	def RollDice(player as Aqui):
		if self.dice.CanRolling(self.direction):
			self.dice.SendMessage("SetOwner", player)
			self.dice.SendMessage("StartRotate", self.direction)
			player.SendMessage("StartRolling", self)

	def ToggleEnable(toggle as bool):
		collider.enabled = toggle
		renderer.enabled = toggle	

	def Disable():
		self.ToggleEnable(false)
		
	def Enable():
		self.ToggleEnable(true)
