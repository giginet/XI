import UnityEngine

class Wall (MonoBehaviour):
	public direction as Direction
	public dice as Dice
	private defaultPosition as Vector3

	def Start ():
		defaultPosition = self.transform.position
	
	def Update ():
		self.transform.position = self.dice.transform.position + self.defaultPosition
		
	def RollDice(player as Aqui):
		if self.dice.CanRolling(self.direction):
			self.dice.SendMessage("SetOwner", player)
			self.dice.SendMessage("StartRotate", self.direction)
			player.SendMessage("StartRolling", self)
