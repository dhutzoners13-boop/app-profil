<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\QuestionResource;
use App\Models\Question;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class QuestionController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $query = Question::query()
            ->with(['topic', 'publishedAnswers.user'])
            ->where('status', 'answered');

        if ($request->filled('topic')) {
            $query->whereHas('topic', function ($q) use ($request) {
                $q->where('slug', $request->query('topic'))
                    ->orWhere('id', $request->query('topic'));
            });
        }

        if ($request->filled('search')) {
            $search = $request->query('search');
            $query->where(function ($q) use ($search) {
                $q->where('subject', 'like', "%{$search}%")
                    ->orWhere('body', 'like', "%{$search}%");
            });
        }

        $questions = $query->latest()
            ->paginate($request->integer('per_page', 10));

        return QuestionResource::collection($questions);
    }

    public function show(int $id): JsonResponse
    {
        $question = Question::query()
            ->with(['topic', 'publishedAnswers.user'])
            ->where('status', 'answered')
            ->findOrFail($id);

        return response()->json([
            'data' => new QuestionResource($question),
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'topic_id' => 'required|exists:question_topics,id',
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255',
            'phone' => 'nullable|string|max:50',
            'subject' => 'required|string|max:255',
            'body' => 'required|string|min:10',
        ]);

        $validated['ip_address'] = $request->ip();
        $validated['status'] = 'pending';

        $question = Question::create($validated);

        return response()->json([
            'message' => 'Pertanyaan Anda berhasil dikirim dan akan segera ditinjau oleh pihak instansi.',
            'data' => [
                'id' => $question->id,
                'subject' => $question->subject,
                'status' => $question->status,
                'created_at' => $question->created_at->toIso8601String(),
            ],
        ], 201);
    }
}
