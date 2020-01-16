<?php

namespace App\Tests\Service;

use App\Service\Calculator;
use PHPUnit\Framework\TestCase;

class CalculatorTest extends TestCase
{
    public function testAdd()
    {
        $calculator = new Calculator();
        $this->assertEquals(2, $calculator->add(1, 1));
    }
}
