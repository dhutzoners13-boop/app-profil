<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class QuestionResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'subject' => $this->subject,
            'body' => $this->body,
            'status' => $this->status,
            'topic' => new QuestionTopicResource($this->whenLoaded('topic')),
            'answers' => QuestionAnswerResource::collection($this->whenLoaded('publishedAnswers')),
            'created_at' => $this->created_at?->toIso8601String(),
        ];
    }
}
