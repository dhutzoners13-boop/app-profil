<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\MenuResource;
use App\Models\Menu;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class MenuController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $menus = Menu::query()
            ->where('is_active', true)
            ->with(['rootItems' => fn ($q) => $q->where('is_active', true)->with('children')])
            ->get();

        return MenuResource::collection($menus);
    }

    public function show(string $location): JsonResponse
    {
        $menu = Menu::query()
            ->where('is_active', true)
            ->where('location', $location)
            ->with(['rootItems' => fn ($q) => $q->where('is_active', true)->with('children')])
            ->firstOrFail();

        return response()->json([
            'data' => new MenuResource($menu),
        ]);
    }
}
