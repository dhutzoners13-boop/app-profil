<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class PostResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'slug' => $this->slug,
            'summary' => $this->summary,
            'content' => $this->content,
            'image' => $this->image ? Storage::disk('public')->url($this->image) : null,
            'status' => $this->status,
            'view_count' => $this->view_count,
            'is_featured' => $this->is_featured,
            'published_at' => $this->published_at?->toIso8601String(),
            'category' => new CategoryResource($this->whenLoaded('category')),
            'author' => [
                'name' => $this->user?->name,
                'avatar' => $this->user?->avatar ? Storage::disk('public')->url($this->user->avatar) : null,
            ],
            'created_at' => $this->created_at?->toIso8601String(),
        ];
    }
}
