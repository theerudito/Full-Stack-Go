package main

import (
	"database/sql"
	"log"
	"os"

	"github.com/gofiber/fiber/v2"
	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

type Personaje struct {
	ID     int    `json:"id"`
	Nombre string `json:"nombre"`
	Clan   string `json:"clan"`
	Edad   int    `json:"edad"`
}

func main() {
	// Cargar variables de entorno desde .env (solo en desarrollo)
	if os.Getenv("ENVIRONMENT") != "production" {
		err := godotenv.Load(".env")
		if err != nil {
			log.Printf("Error al cargar .env: %v", err)
		}
	}

	connStr := os.Getenv("DATABASE_URL")
	if connStr == "" {
		log.Fatal("DATABASE_URL no definida")
	}

	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	app := fiber.New()

	app.Get("/", func(c *fiber.Ctx) error {
		rows, err := db.Query("SELECT id, nombre, clan, edad FROM Personajes")
		if err != nil {
			return c.Status(500).JSON(fiber.Map{"error": err.Error()})
		}
		defer rows.Close()

		var personajes []Personaje
		for rows.Next() {
			var p Personaje
			if err := rows.Scan(&p.ID, &p.Nombre, &p.Clan, &p.Edad); err != nil {
				return c.Status(500).JSON(fiber.Map{"error": err.Error()})
			}
			personajes = append(personajes, p)
		}

		return c.JSON(personajes)
	})

	log.Fatal(app.Listen(":3030"))
}
