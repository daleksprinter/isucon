package main

func queryChannels() ([]int64, error) {
	res := []int64{}
	err := db.Select(&res, "SELECT id FROM channel")
	return res, err
}

func queryMessages(chanID, lastID int64) ([]MessageAndUser, error) {
	msgs := []MessageAndUser{}
	err := db.Select(&msgs, "SELECT m.*, u.id as user_pk, u.name, u.salt, u.password, u.display_name, u.avatar_icon, u.created_at as user_created_at FROM message AS m JOIN user AS u ON m.user_id = u.id WHERE m.id > ? AND m.channel_id = ? ORDER BY m.id DESC LIMIT 100",
		lastID, chanID)
	return msgs, err
}

func addMessage(channelID, userID int64, content string) (int64, error) {
	res, err := db.Exec(
		"INSERT INTO message (channel_id, user_id, content, created_at) VALUES (?, ?, ?, NOW())",
		channelID, userID, content)
	if err != nil {
		return 0, err
	}

	id, err := res.LastInsertId()
	if err != nil {
		return 0, err
	}

	m := Message{}
	err = db.Get(&m, "select * from message where id = ?", id)
	if err != nil {
		return 0, err
	}

	err = setMessageID(&m)
	if err != nil {
		return 0, err
	}

	return id, nil
}
