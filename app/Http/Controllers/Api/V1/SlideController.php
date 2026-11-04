<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\SlideResource;
use App\Models\Slide;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class SlideController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $slides = Slide::query()
            ->active()
            ->get();

        return SlideResource::collection($slides);
    }
}
