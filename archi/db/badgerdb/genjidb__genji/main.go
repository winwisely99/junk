package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"

	"github.com/dgraph-io/badger/v2"
	"github.com/genjidb/genji"
	"github.com/genjidb/genji/document"

	"github.com/genjidb/genji/engine/badgerengine"
)

// Mathematical constants.
const (
	// table names

	TableNameBlob = "files"
	//TableNameBlob = "blobs" // THIS FAILS. Nothing else i tried fails so far.

	TableNameUser = "users"
)

func main() {
	// Create a badger engine
	db := makeDb("mydb")
	defer db.Close()

	// Make Schema
	makeSchema(db)

	// Make Data
	insert(db)

	// Query some documents
	query(db)
	query1(db)

	// Insert, Query files
	blob(db)

}

// User ...
type User struct {
	ID      int64
	Name    string
	Age     uint32
	Address struct {
		City    string
		ZipCode string
	}
}

// Blob ...
type Blob struct {
	ID    int64
	Name  string
	Ext   string
	Bytes []byte
	Len   int
}

func makeDb(name string) (db *genji.DB) {
	// Create a badger engine
	ng, err := badgerengine.NewEngine(badger.DefaultOptions(name))
	if err != nil {
		log.Fatal(err)
	}

	// Subscribe access :)
	// ng.DB.Subscribe(ctx context.Context, cb func(kv *KVList) error, prefixes ...[]byte)

	// Pass it to genji
	db, err = genji.New(ng)
	if err != nil {
		log.Fatal(err)
	}

	return db
}

func makeSchema(db *genji.DB) {
	// DO in a transaction
	tx, err := db.Begin(true)
	if err != nil {
		panic(err)
	}
	defer tx.Rollback()

	// Users
	s := fmt.Sprintf("CREATE TABLE IF NOT EXISTS %s", TableNameUser)
	err = tx.Exec(s)
	if err != nil {
		panic(err)
	}
	s = fmt.Sprintf("CREATE INDEX IF NOT EXISTS idx_user_name ON %s (name)", TableNameUser)
	err = tx.Exec(s)
	if err != nil {
		panic(err)
	}

	// Files
	s = fmt.Sprintf("CREATE TABLE IF NOT EXISTS %s", TableNameBlob)
	err = tx.Exec(s)
	if err != nil {
		panic(err)
	}

	err = tx.Commit()
	if err != nil {
		err = tx.Rollback()
		panic(err)
	}
}

func insert(db *genji.DB) {
	// Insert some data
	s := fmt.Sprintf("INSERT INTO %s (id, name, age) VALUES (?, ?, ?)", TableNameUser)
	err := db.Exec(s, 10, "foo", 15)
	if err != nil {
		panic(err)
	}

	// Insert some data using document notation
	/*
		err = db.Exec(`INSERT INTO user VALUES {id: 12, "name": "bar", age: ?, address: {city: "Lyon", zipcode: "69001"}}`, 16)
		if err != nil {
			panic(err)
		}
	*/

	// Structs can be used to describe a document
	s = fmt.Sprintf("INSERT INTO %s VALUES ?, ?", TableNameUser)
	err = db.Exec(s, &User{ID: 1, Name: "baz", Age: 100}, &User{ID: 2, Name: "bat"})
	if err != nil {
		panic(err)
	}

}

func query(db *genji.DB) {

	s := fmt.Sprintf("SELECT * FROM %s WHERE id > ?", TableNameUser)
	stream, err := db.Query(s, 1)
	if err != nil {
		panic(err)
	}

	defer stream.Close()

	// Iterate over the results
	err = stream.Iterate(func(d document.Document) error {
		var u User

		err = document.StructScan(d, &u)
		if err != nil {
			return err
		}

		fmt.Println(u)
		return nil
	})
	if err != nil {
		panic(err)
	}
}

func query1(db *genji.DB) {

	s := fmt.Sprintf("SELECT pk(), name FROM %s", TableNameUser)
	stream, err := db.Query(s)
	defer stream.Close()

	// Iterate over the results
	err = stream.Iterate(func(d document.Document) error {
		var u User

		err = document.StructScan(d, &u)
		if err != nil {
			return err
		}

		fmt.Println(u)
		return nil
	})
	if err != nil {
		panic(err)
	}

}

func blob(db *genji.DB) {

	// Best way apparently is to use genji and store the data in a blob column

	// Get file sfor disk.
	filename := "test.txt"
	file, err := os.Open(filename)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	data, err := ioutil.ReadAll(file)
	if err != nil {
		log.Fatal(err)
	}

	// Make instance
	blob := Blob{}

	fmt.Printf("Data as string: %s\n", data)
	fmt.Println("Number of bytes read:", len(data))

	blob.ID = 001
	blob.Name = file.Name()
	blob.Bytes = data
	blob.Len = len(data)

	fmt.Println(blob)

	// Insert into the Db
	s := fmt.Sprintf("INSERT INTO %s VALUES ?", TableNameBlob)
	err = db.Exec(s, &blob)
	if err != nil {
		panic(err)
	}

	// Get the same file back from the DB
	s = fmt.Sprintf("SELECT * FROM %s WHERE id = ?", TableNameBlob)
	d, err := db.QueryDocument(s, &blob.ID)
	if err != nil {
		panic(err)
	}
	var b Blob
	err = document.StructScan(d, &b)
	if err != nil {
		panic(err)
	}

	fmt.Println(b)

	fileout := "testout.txt"
	err = ioutil.WriteFile(fileout, b.Bytes, 0644)
	if err != nil {
		panic(err)
	}

}
