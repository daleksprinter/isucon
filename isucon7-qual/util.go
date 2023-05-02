package main

func tAdd(a, b int64) int64 {
	return a + b
}

func tRange(a, b int64) []int64 {
	r := make([]int64, b-a+1)
	for i := int64(0); i <= (b - a); i++ {
		r[i] = a + i
	}
	return r
}

func jsonifyMessage(m MessageAndUser) (map[string]interface{}, error) {
	u := User{
		m.UserPK,
		m.UserName,
		m.UserSalt,
		m.UserPassword,
		m.UserDisplayName,
		m.UserAvatarIcon,
		m.UserCreatedAt,
	}

	r := make(map[string]interface{})
	r["id"] = m.ID
	r["user"] = u
	r["date"] = m.CreatedAt.Format("2006/01/02 15:04:05")
	r["content"] = m.Content
	return r, nil
}
