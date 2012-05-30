import UnityEngine

enum PlayerState:
	Normal
	Rolling
	Death

class Aqui (MonoBehaviour): 
	
	private currentDice as GameObject
	private state as PlayerState
	
	def Start ():
		pass
					
	def Update ():
		pass
			
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
					wall as Wall = obj.GetComponent("Wall")
					if wall.dice.CanRolling(wall.direction):
						wall.Enable()
					else:
						wall.Disable()