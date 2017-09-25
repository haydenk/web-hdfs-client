<?php

namespace haydenk\WebHDFS;

use GuzzleHttp\Client;
use GuzzleHttp\Exception\RequestException;
use Psr\Http\Message\UriInterface;

class HdfsClient extends Client
{
    /**
     * @var string
     */
    private $user;

    public function __construct($user, array $config = [])
    {
        $this->user = $user;
        parent::__construct($config);
    }

    /**
     * @return bool
     */
    public function isOnline()
    {
        return ($this->getConfig('base_uri') instanceof UriInterface)
            && $this->ping();
    }

    /**
     * @return bool
     */
    public function rootExists()
    {
        try {
            $fileStatus = $this->get($this->getUserRequestUri(), [
                'query' => [
                    'user.name' => $this->user,
                    'op' => 'GETFILESTATUS',
                ],
            ]);

            $response = \GuzzleHttp\json_decode($fileStatus->getBody()->getContents());

            if($response->FileStatus) {
                return ($response->FileStatus->type === 'DIRECTORY');
            }

        } catch (RequestException $e) {
            return false;
        }

        return false;
    }

    /**
     * @return bool
     */
    public function ping()
    {
        try {
            $response = $this->head('');
            return $response->getStatusCode() === 200;
        } catch (RequestException $e) {
            return false;
        }
        return false;
    }

    /**
     * @return string
     */
    private function getUserRequestUri()
    {
        return '/webhdfs/v1/user/' . $this->user;
    }
}