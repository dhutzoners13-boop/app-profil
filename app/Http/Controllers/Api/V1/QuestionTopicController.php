<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\QuestionTopicResource;
use App\Models\QuestionTopic;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class QuestionTopicController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $topics = QuestionTopic::query()
            ->where('is_active', true)
            ->withCount(['questions' => fn ($q) => $q->where('status', 'answered'), 'faqs' => fn ($q) => $q->where('is_active', true)])
            ->orderBy('sort_order')
            ->get();

        return QuestionTopicResource::collection($topics);
    }

    public function show(string $slug): JsonResponse
    {
        $topic = QuestionTopic::query()
            ->where('is_active', true)
            ->where('slug', $slug)
            ->withCount(['questions' => fn ($q) => $q->where('status', 'answered'), 'faqs' => fn ($q) => $q->where('is_active', true)])
            ->firstOrFail();

        return response()->json([
            'data' => new QuestionTopicResource($topic),
        ]);
    }
}
