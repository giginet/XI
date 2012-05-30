import UnityEngine

enum PlayerState:
	Normal
	Rolling
	Death

class Aqui (MonoBehaviour): 
	
	public currentDice as GameObject
	private state as PlayerState
	private wall as GameObject
	
	def Start ():
		wall = GameObject.Find("Wall")
					
	def Update ():
		dice as Dice = self.currentDice.GetComponent[of Dice]()
		v = Field.MatrixToPosition(dice.Matrix())
		wall.transform.position = v + Vector3.up * Setting.DICE_SIZE
			
	def OnGround(otherObject as Collider):
		print("ground")
		if otherObject.tag == "Dice":
			self.CheckNeighbor()
		
	def OnOutGround(otherObject as Collider):
		pass
		
	def OnControllerColliderHit(hit as ControllerColliderHit):
		obj as GameObject = hit.gameObject
		if obj.tag == "Wall" and self.state == PlayerState.Normal:
			obj.SendMessage("RollDice", self)
		elif obj.tag == "Dice":
			self.currentDice = obj
			
	def StartRolling(wall as Wall):
		self.state = PlayerState.Rolling
			
	def EndRolling():
		self.state = PlayerState.Normal
		self.CheckNeighbor()
		
	def CheckNeighbor():
		if self.currentDice:
			for obj as Transform in self.currentDice.transform:
				if obj.tag == "Wall":
					dice as Dice = self.currentDice.GetComponent[of Dice]()
					w as Wall = obj.GetComponent("Wall")
					if dice.CanRolling(w.direction):
						w.Enable()
					else:
						w.Disable()