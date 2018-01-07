<?php
namespace haydenk\WebHDFS;

use GuzzleHttp\ClientInterface;
use PHPUnit\Framework\TestCase;

class HdfsClientTest extends TestCase
{
    /**
     * @var ClientInterface
     */
    private $client;

    protected function setUp()
    {
        $this->client = new HdfsClient('hadoop');
    }

    public function testHello()
    {
        $this->assertEquals('hadoop', $this->client->)
    }
}
