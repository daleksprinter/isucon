package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"time"

	_ "github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
	"github.com/joho/godotenv"
)

var (
	envfile = flag.String("env", "./env.sh", "Env file")
	outpath = flag.String("o", "./icons", "Output directory")
)

func connectDb() (db *sqlx.DB, err error) {
	dbHost := os.Getenv("ISUBATA_DB_HOST")
	if dbHost == "" {
		dbHost = "127.0.0.1"
	}
	dbPort := os.Getenv("ISUBATA_DB_PORT")
	if dbPort == "" {
		dbPort = "3306"
	}
	dbUser := os.Getenv("ISUBATA_DB_USER")
	if dbUser == "" {
		dbUser = "isucon"
	}
	dbPassword := "isucon"
	if dbPassword != "" {
		dbPassword = ":isucon"
	}

	dsn := fmt.Sprintf(
		"%s%s@tcp(%s:%s)/isubata?parseTime=true&loc=Local&charset=utf8mb4",
		dbUser, dbPassword, dbHost, dbPort)

	fmt.Printf("Connecting to db: %q\n", dsn)

	db, err = sqlx.Connect("mysql", dsn)
	if err != nil {
		return
	}

	for i := 0; i < 10; i++ {
		err = db.Ping()
		if err == nil {
			break
		}
		fmt.Println(err)
		time.Sleep(time.Second * 3)
	}
	if err != nil {
		return
	}

	db.SetMaxOpenConns(1)
	db.SetConnMaxLifetime(1 * time.Minute)

	fmt.Println("Succeeded to connect db.")
	return
}

func extractImg(db *sqlx.DB) error {
	type Image struct {
		Name string `db:"name"`
		Data []byte `db:"data"`
	}

	fmt.Printf("Extracting icon images to %s\n", *outpath)

	// image テーブルは初期状態で1001行あるので, ぱっと見全件取得はメモリやばそう.
	// でもよくよく調べると, ファイル名の重複が大量にあって,
	// 実質保存されてる画像は多くても100枚なので, 一気に全件取得しちゃう
	images := []Image{}
	err := db.Select(&images,
		"SELECT name, MAX(data) AS data FROM image GROUP BY name")
	if err != nil {
		return err
	}

	// outpath 以下にファイル書き出し
	for _, image := range images {
		f, err := os.Create(*outpath + "/" + image.Name)
		if err != nil {
			return err
		}
		defer f.Close()
		_, err = f.Write(image.Data)
		if err != nil {
			return err
		}
	}

	fmt.Println("Succeeded to extract icon images.")
	return nil
}

func main() {
	flag.Parse()

	if err := godotenv.Load(*envfile); err != nil {
		log.Fatalf("Loading .env file failed: %v\n", err)
	}

	os.Mkdir(*outpath, 0777)

	db, err := connectDb()
	if err != nil {
		log.Fatalln(err)
	}

	if err := extractImg(db); err != nil {
		log.Fatalln(err)
	}
}
