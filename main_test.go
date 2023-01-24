package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestFunc1(t *testing.T) {
	resultPass := Func1("pass")
	assert.Equal(t, true, resultPass)

	resultFail := Func1("fail")
	assert.Equal(t, false, resultFail)
}