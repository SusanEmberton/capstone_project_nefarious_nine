extends Node

func _ready():
	pass
	
func get_classrooms_where_user_is_member(user_email):
	assert(user_email != null)
	var query : FirestoreQuery = FirestoreQuery.new()\
		.from(Constants.COLLECTIONS.CLASSROOMS)\
		.where("members", FirestoreQuery.OPERATOR.ARRAY_CONTAINS, user_email)
	var query_task : FirestoreTask = Firebase.Firestore.query(query)
	var res = yield(query_task, "task_finished")
	return res.data 

func get_user_document(user_id):
	var collection : FirestoreCollection = Firebase.Firestore.collection('users')
	var document_task : FirestoreTask = collection.get(user_id)
	var document : FirestoreDocument = yield(document_task, "get_document")
	return document
	
func add_new_multiplayer_lobby(lobby_fields):
	assert(typeof(lobby_fields) == TYPE_DICTIONARY)
	var collection : FirestoreCollection = Firebase.Firestore.collection(Constants.COLLECTIONS.MULTIPLAYER_GAME_LOBBIES)
	var add_task : FirestoreTask = collection.add('', lobby_fields)
	yield(add_task, "task_finished")

func get_multiplayer_lobbies(classroom_list):
	assert(typeof(classroom_list) == TYPE_ARRAY)
	var query : FirestoreQuery = FirestoreQuery.new()\
		.from(Constants.COLLECTIONS.MULTIPLAYER_GAME_LOBBIES)\
		.where("classroom", FirestoreQuery.OPERATOR.IN, classroom_list)
	var query_task : FirestoreTask = Firebase.Firestore.query(query)
	var res : Array = yield(query_task, "task_finished").data
	return res