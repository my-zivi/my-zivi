<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTableUserFeedback extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('user_feedbacks', function (Blueprint $table) {
            $table->increments('id');
            $table->timestamps();
            $table->softDeletes();
            $table->integer('user')->unsigned();
            $table->foreign('user')->references('id')->on('users');
            $table->date('year');
            $table->string('questionId');
            $table->string('answer');
            /*
                $table->integer('f0');
                $table->integer('f1');
                $table->integer('f2');
                $table->integer('f3');
                $table->integer('f4');
                $table->integer('f5');
                $table->integer('f6');
                $table->integer('f7');
                $table->integer('f8');
                $table->integer('f9');
                $table->integer('f10');
                $table->integer('f11');
                $table->integer('f12');
                $table->integer('f13');
                $table->integer('f14');
                $table->integer('f15');
                $table->integer('f16');
                $table->integer('f17');
                $table->integer('f18');
                $table->integer('f19');
                $table->integer('f20');
                $table->integer('f21');
                $table->integer('f22');
                $table->integer('f23');
                $table->integer('f24');
                $table->integer('f25');
                $table->integer('f26');
                $table->integer('f27');
                $table->integer('f28');
                $table->integer('f29');
                $table->integer('f30');
                $table->integer('f31');
                $table->integer('f32');
                $table->integer('f33');
                $table->integer('f34');
                $table->integer('f35');
                $table->integer('f36');
                $table->integer('f37');
                $table->integer('f38');
                $table->string('f39');
                $table->integer('f40');
                $table->integer('f41');
                $table->integer('f42');
                $table->integer('f43');
                $table->string('f44');
                $table->integer('f45');
                $table->integer('f46');
                $table->integer('f47');
                $table->integer('f48');
                $table->string('f49');
                $table->integer('f50');
                $table->integer('f51');
                $table->integer('f52');
                $table->integer('f53');
                $table->string('f54');
                $table->integer('f55');
                $table->integer('f56');
                $table->string('f57');
                $table->string('f58');
                $table->string('f59');
                $table->string('f60');
            */
        });
    }
}
