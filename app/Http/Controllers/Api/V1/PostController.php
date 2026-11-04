<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\PostResource;
use App\Models\Post;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class PostController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $query = Post::query()
            ->with(['category', 'user'])
            ->published();

        if ($request->filled('category')) {
            $query->whereHas('category', function ($q) use ($request) {
                $q->where('slug', $request->query('category'))
                    ->orWhere('id', $request->query('category'));
            });
        }

        if ($request->filled('search')) {
            $search = $request->query('search');
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                    ->orWhere('summary', 'like', "%{$search}%")
                    ->orWhere('content', 'like', "%{$search}%");
            });
        }

        if ($request->boolean('featured')) {
            $query->where('is_featured', true);
        }

        $posts = $query->orderBy('published_at', 'desc')
            ->paginate($request->integer('per_page', 10));

        return PostResource::collection($posts);
    }

    public function show(string $slug): JsonResponse
    {
        $post = Post::query()
            ->with(['category', 'user'])
            ->published()
            ->where('slug', $slug)
            ->firstOrFail();

        $post->increment('view_count');

        return response()->json([
            'data' => new PostResource($post),
        ]);
    }
}
