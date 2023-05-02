package main

import (
	"fmt"
	"github.com/gomodule/redigo/redis"
)

func channelMessageKey(chID int64) string {
	return fmt.Sprintf("channels/%d/messages", chID)
}

func getMessageCount(chID int64) (int64, error) {
	conn := pool.Get()
	defer conn.Close()
	cnt, err := redis.Int64(conn.Do("ZCARD", channelMessageKey(chID)))
	if err != nil {
		return 0, err
	}
	return cnt, nil
}

func getUnreadMessageCount(chID int64, lastRead int64) (int64, error) {
	conn := pool.Get()
	defer conn.Close()

	cnt, err := redis.Int64(conn.Do("ZREVRANK", channelMessageKey(chID), lastRead))
	if err != nil {
		return 0, err
	}
	return cnt, nil
}

func setMessageID(m *Message) error {
	conn := pool.Get()
	defer conn.Close()

	_, err := conn.Do("ZADD", channelMessageKey(m.ChannelID), m.CreatedAt.UnixNano(), m.ID)
	return err

}

func lastReadKey(userID int64) string {
	return fmt.Sprintf("users/%d/lastread", userID)
}

func getLastReadID(userID int64, channelID int64) (int64, error) {
	conn := pool.Get()
	defer conn.Close()
	return redis.Int64(conn.Do("HGET", lastReadKey(userID), channelID))
}

func setLastReadID(userID int64, channelID int64, messageID int64) error {
	conn := pool.Get()
	defer conn.Close()
	_, err := conn.Do("HSET", lastReadKey(userID), channelID, messageID)
	return err
}
