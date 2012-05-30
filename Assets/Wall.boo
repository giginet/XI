import UnityEngine

class Wall (MonoBehaviour):
	public direction as Direction
	private defaultPosition as Vector3

	def Start ():
		defaultPosition = self.transform.localPosition
	
	def Update ():
		self.CheckThrough()
		
	def RollDice(player as Aqui):
		d = player.currentDice
		if not d: return
		dice = d.GetComponent[of Dice]()
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

	def CheckThrough():
		player = GameObject.FindWithTag("Player")
		aqui = player.GetComponent[of Aqui]()
		if aqui.currentDice:
			dice = aqui.currentDice.GetComponent[of Dice]()
			self.ToggleEnable(not dice.CanThrough(self.direction))