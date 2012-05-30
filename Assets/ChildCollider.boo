import UnityEngine

class ChildCollider (MonoBehaviour): 
	
	public enterReciverName as string
	public stayReciverName as string
	public exitReciverName as string

	def Start ():
		pass
	
	def Update ():
		pass

	def OnTriggerEnter(otherObject as Collider):
		if not enterReciverName: return
		gameObject.transform.parent.gameObject.SendMessage(enterReciverName, otherObject)

	def OnTriggerStay(otherObject as Collider):
		if not stayReciverName: return
		gameObject.transform.parent.gameObject.SendMessage(stayReciverName, otherObject)

	def OnTriggerExit(otherObject as Collider):
		if not exitReciverName: return
		gameObject.transform.parent.gameObject.SendMessage(exitReciverName, otherObject)
