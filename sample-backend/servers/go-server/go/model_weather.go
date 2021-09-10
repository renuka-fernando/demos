/*
 * Sample Backend
 *
 * This is a sample backend
 *
 * API version: v1
 * Contact: renukapiyumal@gmail.com
 * Generated by: Swagger Codegen (https://github.com/swagger-api/swagger-codegen.git)
 */
package swagger

type Weather struct {
	Datetime int32 `json:"datetime,omitempty"`

	Temp float64 `json:"temp,omitempty"`

	FeelsLike float64 `json:"feels_like,omitempty"`

	Pressure int32 `json:"pressure,omitempty"`

	Humidity int32 `json:"humidity,omitempty"`
}