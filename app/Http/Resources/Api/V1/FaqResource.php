<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class FaqResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'topic_id' => $this->topic_id,
            'topic' => new QuestionTopicResource($this->whenLoaded('topic')),
            'question' => $this->question,
            'answer' => $this->answer,
            'sort_order' => $this->sort_order,
        ];
    }
}
