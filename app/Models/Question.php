<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Question extends Model
{
    use HasFactory;

    protected $fillable = [
        'topic_id',
        'name',
        'email',
        'phone',
        'subject',
        'body',
        'status',
        'ip_address',
    ];

    public function topic(): BelongsTo
    {
        return $this->belongsTo(QuestionTopic::class, 'topic_id');
    }

    public function answers(): HasMany
    {
        return $this->hasMany(QuestionAnswer::class);
    }

    public function publishedAnswers(): HasMany
    {
        return $this->answers()->where('is_published', true);
    }

    public function scopeAnswered(Builder $query): Builder
    {
        return $query->where('status', 'answered');
    }
}
